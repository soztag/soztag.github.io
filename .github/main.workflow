workflow "Deploy" {
  on = "push"
  resolves = [
    "Deploy via Rsync"
  ]
}

action "Master" {
  uses = "actions/bin/filter@c6471707d308175c57dfe91963406ef205837dbd"
  args = "branch master"
}

action "Deploy via Rsync" {
  uses = "maxheld83/rsync@v0.1.1"
  needs = "Master"
  secrets = [
    "SSH_PRIVATE_KEY",
    "SSH_PUBLIC_KEY",
  ]
  env = {
    HOST_NAME = "karli.rrze.uni-erlangen.de"
    HOST_IP = "131.188.16.138"
    HOST_FINGERPRINT = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFHJVSekYKuF5pMKyHe1jS9mUkXMWoqNQe0TTs2sY1OQj379e6eqVSqGZe+9dKWzL5MRFpIiySRKgvxuHhaPQU4="
  }
  args = [
    "-r", # otherwise everything in child folders gets deleted
    "$GITHUB_WORKSPACE/index.html",
    "pfs400wm@$HOST_NAME:/proj/websource/docs/FAU/fakultaet/phil/www.datascience.phil.fau.de/websource/",
  ]
}
