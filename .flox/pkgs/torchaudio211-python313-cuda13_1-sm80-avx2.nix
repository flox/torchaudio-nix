# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA A100, A30 (SM80) — AVX2 — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "80"; isa = "avx2"; cudaVersion = "13_1"; }
