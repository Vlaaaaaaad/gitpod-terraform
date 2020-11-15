# Load completion for terrafom docs
source <(terraform-docs completion bash)

alias tf="terraform "
complete -C /home/linuxbrew/.linuxbrew/bin/terraform terraform
complete -C /home/linuxbrew/.linuxbrew/bin/terraform tf

export PS1="┌─── \u @ ☁️ : \n│    \w \n└ "
