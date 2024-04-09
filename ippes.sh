#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091,SC2086

# IPP Everywhere sucks
# A small project to allow old printers to be installed without IPP Everywhere.
#
# Made by Jiab77 - 2023
#
# Version 0.0.0

# Options
set -o xtrace

# Colors
NC="\033[0m"
NL="\n"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
RED="\033[1;31m"
WHITE="\033[1;37m"
PURPLE="\033[1;35m"

# Config
DEBUG_MODE=false
DRY_RUN=false
REMOVE_ALL=false

# Functions
function get_version() {
    grep -i 'version' "$0" | awk '{ print $3 }' | head -n1
}
function show_version() {
    echo -e "\nVersion: $(get_version)\n" ; exit
}
function show_usage() {
    echo -e "\nUsage: $(basename "$0") <ACTION> [OPTIONS]\n"
    echo -e "Action:\n"
    echo -e "show\tShow installed printers."
    echo -e "\nOptions:\n"
    echo -e "-h|--help\tShow this message."
    echo -e "-v|--version\tShow script version."
    echo -e "-d|--debug\tEnable debug mode."
    echo -e "-a|--all\tRemove all installed printers."
    echo -e "-n|--dry-run\tSimulate changes, don't apply them."
    echo -e "\nDisclaimer:\n\n/!\ This script is still experimental so use it with caution. /!\ \n"
    exit
}
function die() {
    echo -e "\nError: $*\n" >&2
    exit 255
}
function init_ippes() {
    case $IPPES_ACTION in
        "show") ippes_show ;;
        "remove") ippes_remove ;;
    esac
}
function ippes_show() {
    echo -e "${NL}${WHITE}Listing installed printers...${NC}${NL}"
    lpstat -t
    echo -e "${NL}${WHITE}Done.${NC}${NL}"
}
function ippes_remove() {
    local PRINTERS_LIST=()
    local PRINTERS_FOUND=0
    local PRINTER_INDEX=0
    local OLD_IFS=$IFS

    if [[ $REMOVE_ALL == true ]]; then
        echo -e "${NL}${WHITE}Removing ${YELLOW}all${WHITE} installed printers...${NC}${NL}"
        for P in $(lpstat -e) ; do lpadmin -x $P ; done
        echo -e "${NL}${WHITE}Done.${NC}${NL}"
    else
        echo ; read -rp "Define printer brand, model or name: " PRINTER
        if [[ -z $PRINTER ]]; then
            die "Printer not defined."
        else
            echo -e "${NL}${WHITE}Searching for printer '${BLUE}$PRINTER${WHITE}'...${NC}${NL}"
            # PRINTERS_FOUND=$(lpinfo --make-and-model "$PRINTER" -m | sort | uniq | wc -l)
            PRINTERS_FOUND=$(lpstat -p | grep -ci "$PRINTER")
            [[ $PRINTERS_FOUND -eq 0 ]] && PRINTERS_FOUND=$(lpstat -lp | grep -i "$PRINTER" | grep -ci "printer")
            if [[ $PRINTERS_FOUND -eq 0 ]]; then
                die "Could not find any printer brands, models or names that contains '$PRINTER'."
            else
                if [[ $PRINTERS_FOUND -eq 1 ]]; then
                    echo -e "${NL}${WHITE}Removing installed printer '${BLUE}$PRINTER${WHITE}'...${NC}${NL}"
                    lpadmin -x $PRINTER
                    echo -e "${NL}${WHITE}Done.${NC}${NL}"
                else
                    IFS=$'\n'
                    for P in $(lpstat -p | awk '{ print $2 }' | sed -e 's/_/ /g') ; do
                        ((PRINTER_INDEX++))
                        echo "${PRINTER_INDEX}. $P"
                        PRINTERS_LIST+=("$P")
                    done
                    IFS=$OLD_IFS
                    echo ; read -rp "Select the printer you want to remove: " REMOVE_PRINTER
                    if [[ -z $REMOVE_PRINTER ]]; then
                        die "Printer not defined."
                    elif [[ -z ${PRINTERS_LIST[((REMOVE_PRINTER-1))]} ]]; then
                        die "Printer not found."
                    else
                        echo -e "${NL}${WHITE}Selected printer: ${BLUE}${PRINTERS_LIST[((REMOVE_PRINTER-1))]}${NC}${NL}"
                    fi
                fi
            fi
        fi
    fi
}

# Script header
echo -e "${NL}${WHITE}IPP ${YELLOW}Everywhere ${PURPLE}sucks${BLUE} - Manage old printers without ${WHITE}IPP ${YELLOW}Everywhere${BLUE}${NC}"

# Checks
[[ $# -eq 0 ]] && show_usage

# Arguments
INDEX=0
for ARG in "$@"; do
    if [[ $DEBUG_MODE == true ]]; then
        echo "Arg $((INDEX++)): $ARG"
    fi

    case $ARG in
        "show"|"remove")
            IPPES_ACTION="$ARG"
        ;;
        "-h"|"--help") show_usage ;;
        "-v"|"--version") show_version ;;
        "-d"|"--debug") DEBUG_MODE=true ;;
        "-a"|"--all") REMOVE_ALL=true ;;
        "-n"|"--dry-run") DRY_RUN=true ;;
        *)
            die "Unsupported argument given: $ARG"
        ;;
    esac
done

# Main
init_ippes