#!/usr/bin/env bash

vagrant destroy -f
vagrant box update
vagrant up
