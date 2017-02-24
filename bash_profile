export artifactory_username='twinlock'
export artifactory_password='L8T2DQUpAM4kqumZ'

# Setting for the new UTF-8 terminal support in Lion
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Load pyenv automatically by appending
# the following to ~/.bash_profile:
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

#export WORKON_HOME=$HOME/.virtualenvs
#export PROJECT_HOME=$HOME/workspace/virtualEnvDevel
#source /usr/local/bin/virtualenvwrapper.sh
pyenv virtualenvwrapper


if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

export PYTHON_CONFIGURE_OPTS="--enable-framework"
source ~/.bashrc
