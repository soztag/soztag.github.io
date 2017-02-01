#!/bin/sh

Rscript -e "blogdown::install_hugo(version = '0.18.1', force = TRUE)"
Rscript -e "blogdown::build_site()"
