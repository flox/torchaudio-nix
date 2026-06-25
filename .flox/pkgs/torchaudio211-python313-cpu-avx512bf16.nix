# TorchAudio 2.11 (↔ PyTorch 2.11) CPU-only — AVX-512 BF16 (x86_64)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cpu"; isa = "avx512bf16"; }
