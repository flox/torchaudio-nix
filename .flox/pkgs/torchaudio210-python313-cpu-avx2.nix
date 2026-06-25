# TorchAudio 2.10 (↔ PyTorch 2.10) CPU-only — AVX2 (x86_64)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cpu"; isa = "avx2"; }
