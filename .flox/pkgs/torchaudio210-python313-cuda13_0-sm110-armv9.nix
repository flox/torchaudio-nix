# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA DRIVE Thor (SM110) — ARMv9 — CUDA 13.0 (driver 580+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "110"; isa = "armv9"; cudaVersion = "13_0"; }
