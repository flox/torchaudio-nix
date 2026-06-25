# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA GTX 1070, 1080, 1080 Ti, P40 (SM61) — AVX — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "61"; isa = "avx"; cudaVersion = "12_9"; }
