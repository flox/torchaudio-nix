# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA A100, A30 (SM80) — AVX-512 — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "80"; isa = "avx512"; cudaVersion = "13_0"; }
