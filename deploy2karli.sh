echo 'karli.rrze.uni-erlangen.de,131.188.16.138 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFHJVSekYKuF5pMKyHe1jS9mUkXMWoqNQe0TTs2sY1OQj379e6eqVSqGZe+9dKWzL5MRFpIiySRKgvxuHhaPQU4=' >> $HOME/.ssh/known_hosts
# check against known public key
# as per https://docs.travis-ci.com/user/ssh-known-hosts/

eval "$(ssh-agent -s)"
chmod 600 /tmp/karli_rsa
ssh-add /tmp/karli_rsa
# auth etc.
# as per https://docs.travis-ci.com/user/ssh-known-hosts/

rsync -r --delete-after --quiet index.html pfs400wm@karli.rrze.uni-erlangen.de:/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource/
