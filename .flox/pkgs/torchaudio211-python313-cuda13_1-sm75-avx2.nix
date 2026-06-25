# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA T4, RTX 2080 Ti (SM75) — AVX2 — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "75"; isa = "avx2"; cudaVersion = "13_1"; }
