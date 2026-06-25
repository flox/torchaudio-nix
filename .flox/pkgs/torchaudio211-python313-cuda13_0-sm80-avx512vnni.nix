# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA A100, A30 (SM80) — AVX-512 VNNI — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "80"; isa = "avx512vnni"; cudaVersion = "13_0"; }
