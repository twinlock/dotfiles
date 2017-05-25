#!/usr/local/bin/python3
"""This script helps shove java up into vim (its as uncomfortable as it sounds)"""
from xml.etree import ElementTree
import subprocess
import click
import re
import os
import yaml
from pathlib import Path
from os import path
from shutil import which

DEFAULT_PANTS_GEN_DIR=".pants.d/eclipse/eclipse/EclipseGen_eclipse/"
DEFAULT_CONFIG_DIR=".config/eclim_helper/"
CONFIG_DIR=path.join(os.path.expanduser('~'),
        os.environ.get("ECLIM_HELPER_HOME") or DEFAULT_CONFIG_DIR)
LOUD_ECHO=which("figlet") or "echo"

@click.group()
def cli(): pass

@cli.command()
@click.option("--project", default="sq_java")
@click.option("--loc", default=DEFAULT_PANTS_GEN_DIR)
@click.argument("projects", nargs=-1)
def fix_classpath(project, loc, projects):
    cleaned_projects = [proj.strip() for proj in list(projects)]
    project_filename = path.join(loc, project, ".project")
    classpath_filename = path.join(loc, project, ".classpath")
    settings_filename = path.join(loc, project, ".settings", "org.eclipse.jdt.ui.prefs")
    src_re = re.compile("(%s)\..*src\.(main|test)\.java" % ("|".join(cleaned_projects)))

    # first fix project file, which stores the association of package name to disk location
    project_tree = ElementTree.parse(project_filename)
    resources = project_tree.getroot().find("linkedResources")
    for link in resources.findall("link"):
        if link.find("name").text in projects:
            resources.remove(link)
    project_tree.write(project_filename)

    # next fix the actual classpath entries which for some un-fucking-known reason decides to be
    # explicit about all included directories, and eclipse hanldes this really baddly
    classpath_tree = ElementTree.parse(classpath_filename)
    classpath_root = classpath_tree.getroot()
    for cpe in classpath_root.findall("classpathentry"):
        if src_re.match(cpe.attrib["path"]):
            junk = cpe.attrib.pop("including", None)
        elif cpe.attrib["path"] in projects:
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

@cli.command()
@click.option("--project_name", default="sq_java")
@click.argument("projects", nargs=-1)
def pants_rebuild_eclipse(project_name, projects):
    cleaned_projects = [proj.strip() for proj in list(projects)]
    subprocess.run(["pants","compile"] + [proj + "::" for proj in projects], check=True)
    subprocess.run(["pants","eclipse","--eclipse-project-name=" + project_name]
            + [proj + "::" for proj in projects], check=True)
    fix_classpath(project, DEFAULT_PANTS_GEN_DIR, projects)
    # This wont do anything if your project is already installed
    subprocess.run(["vim","-c", "'ProjectImport %s'" % DEFAULT_PANTS_GEN_DIR, "+qall" ], check=True)

# Its annoying ot have to retype projects all the time, so all this is to make sure i dont have to
# do that all the fucking time
@cli.command()
@click.option("--repo_name", default=os.path.basename(os.getcwd()),
        help="name of the repo to add targets to, defaults to the cwd")
@click.argument("repos", nargs=-1)
def targets(repo_name, repos):
    """list current java targets stored in the ~/.config/eclim_helper/config.yaml file"""
    repos_list = [repo_name] + list(repos)
    config_fname = init_config(False)
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
    config_fname = init_config(False)
    if not config_fname:
        return
    with open(config_fname, 'r') as f:
        cfg = yaml.load(f)
        for repo in repos_list or cfg:
            print("repo '%s'" % repo)
            print("targets: %s" % cfg[repo]["targets"])

@cli.command()
@click.option("--repo_name", help="name of the repo to add")
@click.option("--repo_dir", help="directory where the repo is stored")
@click.argument("targets", nargs=-1)
def add_repo(repo_name, repo_dir, targets):
    """add a repo to the conifg"""
    if not repo_dir or not path.isdir(repo_dir):
        print "must specify at least a valid dir for the repo"
    if not repo_name:
        repo_name = path.basename(repo_dir)
    targets_list = list(targets)
    config_fname = init_config(False)
    if not config_fname:
        return
    with open(config_fname, 'r') as f:
        cfg = yaml.load(f)
        if repo_name in cfg:
            print("Repo %s exists in config use add_targets to add targets" % repo_name)
            print_loud("Bye~")
            return
        cfg[repo_name] = { "location" : repo_dir}
        if len(targets_list) > 0:
            cfg[repo_name]["targets"] = targets_list


@cli.command()
@click.option("--repo_name", default=None,
        help="name of the repo to add targets to, defaults to the cwd")
@click.argument("targets", nargs=-1)
def add_targets(repo_name, targets):
    """add pants targets from the config"""
    targets_list = list(targets)
    if len(targets_list) == 0:
        print("No targets to add!!")
    config_fname = init_config()
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
    config_fname = init_config(False)
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
            print("run add_targets first to add a few targets")
            print_loud("GOOD. DAY.")
            return None
    return config_fname, created

def print_loud(string):
    subprocess.run([LOUD_ECHO, string], check=True)

# commands to add:
#   fresh_start: delete the current project, then recreate it
#   configure_eclipse: needs to setup things like square style, google's formatter, etc.
# commands to fix:
#

# yaml structure ideas:
# global: # project settings applied to everything
#   # acts just like a project
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
