# TorchAudio 2.11 (↔ PyTorch 2.12.1, via upstream's "compatible with future versions of torch" guarantee) for NVIDIA GTX 1070, 1080, 1080 Ti, P40 (SM61) — AVX — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; ptVariant = "pt212"; pythonVersion = "313"; backend = "cuda"; sm = "61"; isa = "avx"; cudaVersion = "12_9"; }
