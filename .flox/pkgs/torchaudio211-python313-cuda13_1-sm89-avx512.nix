# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA L40, RTX 4090 (SM89) — AVX-512 — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "89"; isa = "avx512"; cudaVersion = "13_1"; }
