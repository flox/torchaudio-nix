# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA R100 Ultra (SM121) — ARMv9 — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "121"; isa = "armv9"; cudaVersion = "13_0"; }
