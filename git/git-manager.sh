#!/bin/bash

# Name: Git Manager
# filename: git-manager.sh
# Description: A simple script to manage Git repositories and remotes
# Author: Sam Greenwood
# Version: a0.1
# Date: 2024-05-05

gm() {
    score=0
    caseScore=0
    gitstart=$(git init && git add . && git commit --dry-run) grv=(git remote -v)
    grc(gh repo create) rp=(read -p) gra=(git remote add)
    a1=$(awk '{print $1}') a2=$(awk '{print $2}') a2f=$(awk '{printf "%-10s\n", $2}')
    a1f=$(awk '{printf "%-10s\n", $1}') o=(origin) ecm=(rp "Enter commit message: " message)
    nrepo=(rp "Enter the name of the repository: " repo_name) nbranch=(rp "Do you want to work in a specific branch? (if so, enter branch name): " branch)

    case $1 in
        r|reset-remotes|reset) resetRemotes ;;
        cr|create-repo) collectInfoBoth ;; # Create a new Git repository and create a new remote repository on GitHub
        gce|github-commit-existing) commit_existing ;; # GitHub Commit existing local repository w/ commit dry-run and confirm commit
        list) list $2 ;; # List remotes, branches, tags, etc.
        -al|--advanced-local)           # Advanced local repository management
            case $2 in
            -b|--branch) git branch -a ;; -t|--tag) git tag ;; -c|--commit) git commit --dry-run ;;
            -p|--push) git push ;; -r|--remote) grv ;;
            esac
        ;;
        -ag|--advanced-github)          # Advanced GitHub repository management 
            case $2 in
            -d|--description) description=$3 ;; -p|--private) private=$3 ;; -i|--initialize) initialize=$3 ;;
            esac
        ;;
        -h|--help|help) . ~/.startup/help/gm-help.sh $2 ;;
        *) echo "Invalid option. Use 'gm --help' for usage information." ;;
    esac

    collectInfoBoth() {
        case field in
            -d|--description) description=$value ;;
            -p|--private) private=$value ;;
            -r|--repo) repo_name=$value ;;
            -b|--branch) branch=$value ;;
            -gh|--github) gh_repo=$value ;;
            *)
                $nrepo
                $nbranch
                rp "Do you want to create a remote repository on GitHub? (y/n): " gh_repo
        esac

        if [[ -z $repo_name ]]; then
            $nrepo
        fi
        if [[ -z $branch ]]; then
            $nbranch
        fi
        if [[ -z $gh_repo ]]; then
            rp "Do you want to create a remote repository on GitHub? (y/n): " gh_repo
        fi
        if [[ $gh_repo == "y" ]]; then
            create_gh_repo
        else
            create_local_repo
        fi
    }
    create_gh_repo() {
        local ghc=(grc), create=($ghc "$repo_name" $private --description "$description")
        # if repo name is not provided, ask for it
        if [[ -z $repo_name ]]; then
            $nrepo  
        elif [[ -z $description ]]; then
            rp "Enter a description for the repository: " description
        fi
        elif [[ -z $private ]]; then
            rp "Do you want to create a private repository? (y/n): " private
        fi
        rp "Do you want to confirm the creation of the repository? (y/n): " confirm
        if [[ $confirm == "y" ]]; then
            $create --confirm
        else
            $create
        fi
    }

    create_local_repo() {
        rp "Enter remote Name: " remote && rp "Enter remote URL: " remote_url
        local remote="$remote $remote_url" 
        $gitstart
        rp "Do you want to commit the changes? (y/n): " answer
        case $answer in
            y)  ecm && git commit -m "$message"
                rp "Do you want to push the changes? (y/n): " push && git push -u "$remote" main
                gra "$remote" "$remote_url"
                case $remote in
                    origin) gra origin $remote_url ;; *) gra $remote $remote_url ;;
                esac
            *) echo "Operation cancelled." ;;
        esac
    }

    outputInfo() {
        local repoinfo=(grv $repo_name) sed=(sed 's/"//g') upd=($jup $jcr) 
        local jo=(--json owner --jq '.owner.login') localAdateinfo=($dc $lu)
        local sed-origin=(sed 's/$o/$o (default)/') rurl=(Remote URL: $(grv | a2 | uniq | $sed))
        local rem=(Remote: $(grv | a1 | uniq | $sed)) owner=(Owner: $($repoinfo $jo | $sed))
        case $type in
            github)
                case $owner in
                    User) echo "User: $($repoinfo owner --jq '.owner.login' | $sed)" ;;
                    Organization) echo "Organization: $($repoinfo owner --jq '.owner.login' | $sed)"  owntype="org";;
                esac
                local created_at=$($repoinfo --json created_at --jq '.created_at' | $sed)
                if [ "$created_at" != $($repoinfo --json updated_at --jq '.updated_at' | $sed) ]; then
                    dc="Date Created: $created_at" && lu="Last Updated: $($repoinfo --json updated_at --jq '.updated_at' | $sed)"
                fi
                echo -e "Repository: $repo_name\n$owner\Branch: $branch\n$rem\n$rurl\n$dateinfo"
            ;;
            *) echo -e "Repository: $repo_name\n$owner\nLocal Branch: $branch\n$rem\n$rurl" ;;
        esac
    }

    resetRemotes() {
        local grr=(git remote remove), o=(origin), rr=(echo "Removed remote: $remote")
        echo "Current remotes:"
        $rv | a1 | uniq | sed 's/$o/$o (default)/' | a1f
        rp "Do you want to continue? (y/n): " answer
        if [[ $answer == "y" ]]; then for remote in $(git remote); do
                    case $remote in
                        github) $grr $remote && $rr && echo "$remote > origin" ;;
                        gitgub) echo -e "Oops! There's a typo in your remote name "gitgub"" && $grr $remote && echo "gitgub -> origin" ;;
                        *) $grr $remote && $rr ;;
                    esac 
                done; 
                echo "------"; 
                grv;
            fi
        else
            echo "Operation cancelled."
        fi
    }

    commit_existing() {
        $gitstart
        rp "Do you want to commit the changes? (y/n): " answer
        case $answer in
            y)  ecm 
                git commit -m "$message" &&
                rp "Where do you want to push the changes? (origin/main): " push &&
                case $push in
                    origin) git push origin main ;; *) git push origin $push ;;
                esac
            *) echo "Operation cancelled." ;;
        esac
    }
}