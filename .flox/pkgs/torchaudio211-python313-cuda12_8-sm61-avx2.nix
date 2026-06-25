# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA GTX 1070, 1080, 1080 Ti, P40 (SM61) — AVX2 — CUDA 12.8 (driver 550+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "61"; isa = "avx2"; cudaVersion = "12_8"; }
