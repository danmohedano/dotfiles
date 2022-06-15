#!/bin/bash

# Reads the output of 'sensors' and extracts the CPU's temp
sensors | grep "Package id 0:" | tr -d '+' | awk '{print $4}'
