# [host] extragem configuratia kernel-ului original
scp <target>:/proc/config.gz .
gunzip config.gz

# [host] afisam diferentele dintre cele 2
kdiff3 config .config

# optiunile selectate de noi au valoarea Y, pe cand cele din configuratia original au valoarea M
