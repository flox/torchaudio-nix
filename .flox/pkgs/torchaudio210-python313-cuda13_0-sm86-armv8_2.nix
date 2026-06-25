# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA A40, RTX 3090 (SM86) — ARMv8.2 — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "86"; isa = "armv8_2"; cudaVersion = "13_0"; }
