# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA B200, GB200 (SM100) — AVX-512 VNNI — CUDA 12.8 (driver 550+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "100"; isa = "avx512vnni"; cudaVersion = "12_8"; }
