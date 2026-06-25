# TorchAudio 2.10 (↔ PyTorch 2.10) with MPS GPU acceleration for Apple Silicon — Python 3.13
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "mps"; }
