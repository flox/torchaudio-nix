# TorchAudio 2.11 (↔ PyTorch 2.11) with MPS GPU acceleration for Apple Silicon — Python 3.13
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "mps"; }
