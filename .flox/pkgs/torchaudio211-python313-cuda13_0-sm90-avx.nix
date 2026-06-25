# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA H100, H200, L40S (SM90) — AVX — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "90"; isa = "avx"; cudaVersion = "13_0"; }
