# TorchAudio 2.10 (↔ PyTorch 2.10) CPU-only — ARMv8.2 (aarch64)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cpu"; isa = "armv8_2"; }
