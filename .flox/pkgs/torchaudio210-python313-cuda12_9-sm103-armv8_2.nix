# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA GB300 (SM103) — ARMv8.2 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "103"; isa = "armv8_2"; cudaVersion = "12_9"; }
