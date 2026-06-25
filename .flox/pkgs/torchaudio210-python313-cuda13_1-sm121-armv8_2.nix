# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA R100 Ultra (SM121) — ARMv8.2 — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "121"; isa = "armv8_2"; cudaVersion = "13_1"; }
