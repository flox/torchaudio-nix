# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA V100, Titan V (SM70) — AVX2 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "70"; isa = "avx2"; cudaVersion = "12_9"; }
