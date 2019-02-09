#!/usr/bin/env bash
#
# @author 		Fabrizio Destro
# @copyright	Copyright 2018, Fabrizio Destro
# @license
#  This work is licensed under the terms of the MIT license.
#  For a copy, see <https://opensource.org/licenses/MIT>.

# Script il cui obiettivo è quello di generare le varie versioni delle risorse
# necessarie nello sviluppo Android.

# In android le risorse sono organizzare in una cartella dedicata chiamata res.

# L'utente da in input un file immagine e vuole generare differenti versioni
# dell'immagine, in una prima versione si generino solamente le versioni per le
# varie densità di pixels.

# L'utente deve specificare per quale densità la risorsa è stata create, il
# programma crea poi le varie versioni per le densità mancanti

# MILESTONE
#
# TODO creare una versione dello script che dato un file in ingresso generi i
# vari file scalati in uscita
#
# TODO aggiungere profili per tipologie di immagini, ad esempio un'icon con
# risoluzione di 1024x1024 non ha molto senso

usage() {
	cat << EOU
android-resource

Usage:	android-generate-resources <drawable> (-ldpi | -mdpi | -hdpi | - xhdpi | -xxhdpi | -xxxhdpi) [--generate-dpi=<dpis>]

EOU
}
