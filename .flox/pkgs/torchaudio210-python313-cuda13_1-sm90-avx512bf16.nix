# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA H100, H200, L40S (SM90) — AVX-512 BF16 — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "90"; isa = "avx512bf16"; cudaVersion = "13_1"; }
