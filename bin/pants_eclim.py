#!/usr/local/bin/python3
"""This script helps shove java up into vim (its as uncomfortable as it sounds)"""
from xml.etree import ElementTree
import subprocess
import click
import re
import os
import yaml
import psutil

from pathlib import Path
from os import path
from shutil import which

DEFAULT_PANTS_GEN_DIR=".pants.d/eclipse/eclipse/EclipseGen_eclipse/"
DEFAULT_CONFIG_DIR=".config/pants_eclim/"
CONFIG_DIR=path.join(os.path.expanduser('~'),
        os.environ.get("PANTS_ECLIM_HOME") or DEFAULT_CONFIG_DIR)
LOUD_ECHO=which("figlet") or "echo"

@click.group()
def cli(): pass

@cli.command()
@click.option("--repo_name", help="name of the repository, doesnt need to match anything")
@click.option("--eclipse_project_name", help="name of the eclipse project")
@click.option("--repo_dir", help="directory where the repo is stored")
@click.argument("targets", nargs=-1)
def fix_classpath(repo_name, eclipse_project_name, repo_dir, targets):
    """pants and eclipse (neon at least) are not really compatible, this fixes various issues found
    in the classpath"""
    if not check_eclim_running():
        return
    # first check the config to see if the repo exists, if not
    # add the repo and all the targets using the add_repo method
    repo_cfg = fetch_or_create_cfg(repo_name, repo_dir, eclipse_project_name,
            list(targets) if targets else [])
    if not repo_cfg:
        return
    repo_dir = repo_cfg["location"]
    eclipse_project_name = repo_cfg["eclipse_project_name"]
    cleaned_targets = repo_cfg["targets"]
    print("fixing classpath for project %s for targets %s" %
            (eclipse_project_name, cleaned_targets))

    # if it does exist and there are targets/location, override location/targets with the
    # ones provided.
    project_filename = path.join(repo_dir, ".project")
    classpath_filename = path.join(repo_dir, ".classpath")
    settings_filename = path.join(repo_dir, ".settings", "org.eclipse.jdt.ui.prefs")
    src_re = re.compile("(%s)\..*src\.(main|test)\.java" % ("|".join(cleaned_targets)))

    # first fix project file, which stores the association of package name to disk location
    project_tree = ElementTree.parse(project_filename)
    resources = project_tree.getroot().find("linkedResources")
    for link in resources.findall("link"):
        if link.find("name").text in cleaned_targets:
            resources.remove(link)
    project_tree.write(project_filename)

    # next fix the actual classpath entries which for some un-fucking-known reason decides to be
    # explicit about all included directories, and eclipse hanldes this really baddly
    classpath_tree = ElementTree.parse(classpath_filename)
    classpath_root = classpath_tree.getroot()
    for cpe in classpath_root.findall("classpathentry"):
        if src_re.match(cpe.attrib["path"]):
            junk = cpe.attrib.pop("including", None)
        elif cpe.attrib["path"] in cleaned_targets:
            classpath_root.remove(cpe)
    classpath_tree.write(classpath_filename)

    # finally fix the UI preferences, remove the really odd automatic project settings like
    # using some hacked up twitter formatter or crazy organize import settings, just use whatever
    # you configured the default eclipse settings to be
    ignored_prefixes = ['formatter_profile', 'org.eclipse.jdt.ui']
    with open(settings_filename, 'r+') as f:
        filtered_file = []
        for line in f:
            if not [True for prefix in ignored_prefixes if line.startswith(prefix)]:
                filtered_file.append(line)
        f.writelines(filtered_file)
    subprocess.run(["vim","-c", "'ProjectRefresh %s'" % eclipse_project_name, "+qall" ], check=True)

@cli.command()
@click.option("--repo_name", help="name of the repository, doesnt need to match anything")
@click.option("--eclipse_project_name", help="name of the eclipse project")
@click.option("--repo_dir", help="directory where the repo is stored")
@click.argument("targets", nargs=-1)
def pants_build_eclipse(repo_name, eclipse_project_name, repo_dir, targets):
    """buid/rebuild the specified project and add it to eclipse"""
    if not check_eclim_running():
        return
    targets_list = list(targets) if targets else []
    repo_cfg = fetch_or_create_cfg(repo_name, repo_dir, eclipse_project_name, targets_list)
    if not repo_cfg:
        return
    repo_dir = repo_cfg["location"]
    eclipse_project_name = repo_cfg["eclipse_project_name"]
    cleaned_targets = [proj.strip() for proj in targets_list or repo_cfg["targets"]]
    merged_targets = repo_cfg["targets"] \
            + [tgt for tgt in cleaned_targets if tgt not in repo_cfg["targets"]]
    print("compiling all pants targets %s" % cleaned_targets)
    subprocess.run(["pants","compile"] + [proj + "::" for proj in cleaned_targets], check=True)
    print("creating eclipse project from targets %s" % merged_targets)
    subprocess.run(["pants","eclipse","--eclipse-project-name=" + eclipse_project_name]
            + [proj + "::" for proj in merged_targets], check=True)
    # This wont do anything if your project is already installed
    print("adding eclipse project found at %s" % repo_dir)
    subprocess.run(["vim","-c", "'ProjectImport %s'" % repo_dir, "+qall" ], check=True)
    fix_classpath(repo_name, eclipse_project_name, repo_dir, merged_targets)

@cli.command()
@click.option("--repo_name", help="name of the repository, doesnt need to match anything")
@click.option("--eclipse_project_name", help="name of the eclipse project")
@click.option("--repo_dir", help="directory where the repo is stored")
@click.argument("targets", nargs=-1)
def pants_clean_rebuild_eclipse(repo_name, eclipse_project_name, repo_dir, targets):
    """same as build eclipse, except delete the project from eclipse and reset pants"""
    if not check_eclim_running():
        return
    repo_cfg = fetch_or_create_cfg(repo_name, repo_dir, eclipse_project_name, list(targets))
    if not repo_cfg:
        return
    repo_dir = repo_cfg["location"]
    eclipse_project_name = repo_cfg["eclipse_project_name"]
    cleaned_targets = repo_cfg["targets"]
    print("starting from a fresh clean of pants targets, to avoid this use pants_build_eclipse")
    subprocess.run(["pants","clean-all"], check=True)
    print("deleteing the old project from eclipse, dont worry this doesn't destroy any code")
    subprocess.run(["vim","-c", "'ProjectDelete %s'" % repo_dir, "+qall" ], check=True)
    pants_build_eclipse(repo_name, eclipse_project_name, repo_dir, targets)

# Its annoying ot have to retype targets all the time, so all this is to make sure i dont have to
# do that all the fucking time
@cli.command()
@click.option("--repo_name", default=os.path.basename(os.getcwd()),
        help="name of the repo to add targets to, defaults to the cwd")
@click.argument("repos", nargs=-1)
def targets(repo_name, repos):
    """list current java targets stored in the ~/.config/eclim_helper/config.yaml file"""
    repos_list = [repo_name] + list(repos)
    config_fname, ignored = init_config(False)
    if not config_fname:
        return
    with open(config_fname, 'r') as f:
        cfg = yaml.load(f)
        for repo in repos_list or cfg:
            if repo in cfg:
                print("Targets found for repo '%s'" % repo)
                print(cfg[repo]["targets"])

@cli.command()
@click.argument("repos", nargs=-1)
def show_config(repos):
    """show the parsed of the config file"""
    repos_list = list(repos)
    if repos_list:
        print("Looking for repos %s" % repos_list)
    else:
        print("Looking up all configs")
    config_fname, ignored = init_config(False)
    if not config_fname:
        return
    with open(config_fname, 'r') as f:
        cfg = yaml.load(f)
        current_repo = find_repo(cfg)
        if current_repo:
            print("Currently in the %s repo" % current_repo)
        for repo in repos_list or cfg:
            print("repo '%s'" % repo)
            print("config: %s" % cfg[repo])

@cli.command()
@click.option("--repo_name", help="name of the repository, doesnt need to match anything")
@click.option("--repo_dir", help="directory where the repo is stored")
@click.option("--eclipse_project_name", help="name of the eclipse project")
@click.argument("targets", nargs=-1)
def add_repo(repo_name, repo_dir, eclipse_project_name, targets):
    """add/update a repo to the conifg"""
    if not repo_dir and not repo_name and not eclipse_project_name and not targets:
        print("must specify at least a valid name for the repo")
        print_loud("At least try.")
        return
    if not repo_name:
        repo_name = path.basename(path.basename(os.getcwd()))
    if not eclipse_project_name:
        eclipse_project_name = repo_name
    if not repo_dir:
        repo_dir = path.join(DEFAULT_PANTS_GEN_DIR, eclipse_project_name)
    targets_list = list(targets)
    fetch_or_create_cfg(repo_name, repo_dir, eclipse_project_name, targets, update=True)

@cli.command()
@click.option("--repo_name", default=None,
        help="name of the repo to add targets to, defaults to the cwd")
@click.argument("targets", nargs=-1)
def add_targets(repo_name, targets):
    """add pants targets from the config"""
    targets_list = list(targets)
    if len(targets_list) == 0:
        print("No targets to add!!")
    config_fname, ignored = init_config()
    with open(config_fname, 'r+') as f:
        cfg = yaml.load(f) or {}
        proper_repo = repo_name or find_repo(cfg)
        if proper_repo not in cfg:
            cfg[repo_name] = {"targets": [], "location": os.getcwd()}
        filtered = [tgt for tgt in targets if tgt not in cfg[repo_name]["targets"]]
        cfg[repo_name]["targets"].extend(filtered)
        dump = yaml.dump(cfg)
        f.write(dump)

@cli.command()
@click.option("--repo_name", default=os.path.basename(os.getcwd()),
        help="name of the repo to delete targets from, defaults to the cwd")
@click.argument("targets", nargs=-1)
def del_targets(repo_name, targets):
    """delete pants targets from the config"""
    targets_list = list(targets)
    if len(targets_list) == 0:
        print("No targets to remove!!")
    config_fname, ignored = init_config(False)
    if not config_fname:
        return
    with open(config_fname, 'r+') as f:
        cfg = yaml.load(f) or {}
        if repo_name not in cfg:
            print("repo '%s' was not found in the config, maybe misspelled?")
            return
        filtered_tgts = [tgt for tgt in cfg[repo_name]["targets"] if tgt not in targets]
        cfg[repo_name]["targets"] = filtered_tgts
        dump = yaml.dump(cfg)
        f.write(dump)

@cli.command()
@click.option("--eclipse_install_loc",
        help="where the eclipse app is installed, looking for the Eclipse.app directory")
@click.option("--default_workspace_loc")
def locate_eclipse(eclipse_install_location, default_workspace_loc):
    if not eclipse_install_loc or not default_workspace_loc:
        print("must specify an install location and a workspace dir")
        print_loud("Why not try harder next time.")
    config_fname, ignored = init_config()
    if not config_fname:
        return
    with open(config_fname, 'r+') as f:
        cfg = yaml.load(f) or {}
        general_cfg = cfg.get("general") or {}
        general_cfg["eclipse_install_location"] = eclipse_install_location
        general_cfg["default_workspace_loc"] = default_workspace_loc
        cfg["general"] = general_cfg
        dump = yaml.dump(cfg)
        f.write(dump)

def config_filename():
    return path.join(CONFIG_DIR, "config.yaml")

def find_repo(cfg):
    """get the repo from the pwd or just this dir name"""
    for repo in cfg:
        loc = cfg[repo]["location"]
        pwd = os.getcwd()
        if path.commonprefix([loc, pwd]) not in ['/', os.path.expanduser('~')]:
            return repo
    path.basename(os.getcwd())

def init_config(create=True):
    config_fname = config_filename()
    created = False
    if not os.path.isfile(config_fname):
        if create:
            print("Creating file %s" % config_fname)
            os.makedirs(CONFIG_DIR, exist_ok=True)
            Path(config_fname).touch()
            created = True
        else:
            print("Nothing found at %s that I can read" % config_fname)
            print("run add_repo first to add a few targets")
            print_loud("GOOD. DAY.")
            return None, None
    return config_fname, created

def print_loud(string):
    subprocess.run([LOUD_ECHO, string], check=True)

def fetch_or_create_cfg(repo_name, repo_dir, eclipse_project_name, targets, update=False):
    cleaned_targets = [proj.strip() for proj in targets]
    config_fname, ignored = init_config()
    if not config_fname:
        return
    if repo_dir and not repo_dir.startswith("/"):
        # make relative paths global
        repo_dir = path.join(os.getcwd(), repo_dir)
    repo_cfg = None
    with open(config_fname, 'r+') as f:
        cfg = yaml.load(f) or {}
        proper_repo = repo_name or find_repo(cfg)
        write = False
        if proper_repo not in cfg:
            if not targets:
                print("repo %s has no targets specified" % proper_repo)
                print_loud("Adieu")
                return None
            cfg[proper_repo] = {
                    "location" : repo_dir or path.join(os.getcwd(), DEFAULT_PANTS_GEN_DIR),
                    "eclipse_project_name": eclipse_project_name or sq_java,
                    }
            if len(cleaned_targets) > 0:
                cfg[proper_repo]["targets"] = cleaned_targets
            write = True
        elif update:
            if repo_dir or not cfg[proper_repo]["location"]:
                cfg[proper_repo]["location"] = repo_dir \
                        or path.join(os.getcwd(), DEFAULT_PANTS_GEN_DIR)
                write = True
            if eclipse_project_name or not cfg[proper_repo]["eclipse_project_name"]:
                cfg[proper_repo]["eclipse_project_name"] = eclipse_project_name or "sq_java"
                write = True
            if len(cleaned_targets) > 0:
                cfg[proper_repo]["targets"] = cleaned_targets
                write = True
        if write:
            dump = yaml.dump(cfg)
            f.write(dump)
        repo_cfg = cfg[proper_repo]
    return repo_cfg

def check_eclim_running():
    eclipse = False
    for p in psutil.process_iter():
        if 'eclipse' in p.name():
            eclipse = True
    if not eclipse:
        print("need both eclipse and eclim running")
        print_loud("START ECLIPSE")
    return eclipse

# commands to add:
#   eclipse_install
#   configure_eclipse: needs to setup things like square style, google's formatter, etc.
#      org.eclipse.core.runtime/.settings/org.eclipse.jdt.ui.prefs
# commands to fix:
#

# yaml structure ideas:
# global: # eclipse settings applied to everything
#   eclipse_install_location:  this is where things like eclim will get installed
#   primary_workspace_location: this is where settings like which formatter to use will get
#     installed
# java: # <= doesnt just need to be the java project, but it will be
#   eclipse_project_name: 'sq_java' # name for the project
#   project_location: 'absolute path to project' # name for the project
#   targets:
#     - one
#     - two
#   ui_prefs:
#     key: value

# next steps:
# [ ] create a config file, and methods to update it so i dont have to type shit in every time
# automate all the eclipse/gui steps
#   using eclim commands http://eclim.org/cheatsheet.html
#   ie. project delete, pants_rebuild_eclipse, project import
# ideal entry point: check if eclipse is installed
#   if not, basically follow this madness: http://eclim.org/install.html#install-headless
# and if it is, double check that eclim is intsalled
#   if not, just run an unattended install.

if __name__ == '__main__':
    cli()
