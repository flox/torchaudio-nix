# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA GB300 (SM103) — ARMv9 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "103"; isa = "armv9"; cudaVersion = "12_9"; }
