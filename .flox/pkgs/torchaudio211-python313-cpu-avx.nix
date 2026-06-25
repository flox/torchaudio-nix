# TorchAudio 2.11 (↔ PyTorch 2.11) CPU-only — AVX (x86_64)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cpu"; isa = "avx"; }
