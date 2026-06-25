# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA B200, GB200 (SM100) — AVX2 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "100"; isa = "avx2"; cudaVersion = "12_9"; }
