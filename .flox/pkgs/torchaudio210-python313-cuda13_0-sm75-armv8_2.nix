# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA T4, RTX 2080 Ti (SM75) — ARMv8.2 — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "75"; isa = "armv8_2"; cudaVersion = "13_0"; }
