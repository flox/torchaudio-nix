# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA A100, A30 (SM80) — AVX2 — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "80"; isa = "avx2"; cudaVersion = "13_1"; }
