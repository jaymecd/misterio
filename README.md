# Misterio
Docker-compose based Ansible alternative. It is super-easy to use; it hates spiders (no one is perfect).


# So what?
Misterio is a set of two tiny bash script you can use to "apply" a set of roles to a infinte numbers of hosts.
Less then 60 lines of bash code (sorry Ansible :)

# Why ?
1. The only dependency is a recent version of docker-compose.
2. It do not relay on docker swarm or on K8s. It can run even on ultra-small nano containers on amazon, provided you have little swap (tested)
3. It is agent-less. It depends only on docker-compose and bash on the target.
4. Everything must be versionated to work: you cannot easily "forget" something on your local machine.



# How
For every hostname, define a directory inside hosts/
Put it a env file based on this syntax:
    <rolename>[@inst].env
where @inst is OPTIONAL and can be used to have multiple instance on the same machine.
You need to parametrize the role to support this, because we avoid using "magic way" to pass the inst value.

# The magic
For every roles on the target machine misterio will:
1. copy the corret env file.
2. pass the command you provide to docker-compose
3. fail fast or loop

The "apply" pseudo-command will do a build and up in one step


# Distributed 
A misterio-ssh demo script is provided to show how to propagate it on a set of remote hosts
Misterio ssh need a misterio command followed by a list of target:

```bash
./misterio-ssh.sh apply pi@raspy1 peter@mayhome parker@newserver
./misterio-ssh.sh logs pi@raspy1 peter@mayhome parker@newserver
./misterio-ssh.sh down pi@raspy1 peter@mayhome parker@newserver
```

Misterio-ssh is quite smart; for every target it will
1. Clone a ultra-small version of the repository and send it over the wire to the selected target
   mistrio-ssh will try to use rsync and fallback to scp if needed
2. Remote launch it
3. Stop if an error occurs before step (1)
   Proceed to the next target if it fails


# Tips
Under docker for window, add
COMPOSE_CONVERT_WINDOWS_PATHS=1
on yout env path if you plan to bind stuff like
> /var/run/docker.sock:/var/run/docker.sock

This will enable your roles to run on windows and on linux dameons seamless.
See https://stackoverflow.com/a/52866439/75540 for more details

# The Hype
1. It is trivial to parallelize misterio-ssh or the replace docker-compose with K8s clusters (try and push me back).
2. You can add git submodules below roles/ to link recipe (your personal "ansible galaxy" is docker hub!)
3. No complex stuff to learn: it is DOCKER!

