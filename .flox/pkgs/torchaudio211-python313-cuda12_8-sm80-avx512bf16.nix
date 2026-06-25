# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA A100, A30 (SM80) — AVX-512 BF16 — CUDA 12.8 (driver 550+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "80"; isa = "avx512bf16"; cudaVersion = "12_8"; }
