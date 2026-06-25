# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA B200, GB200 (SM100) — AVX — CUDA 12.8 (driver 550+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "100"; isa = "avx"; cudaVersion = "12_8"; }
