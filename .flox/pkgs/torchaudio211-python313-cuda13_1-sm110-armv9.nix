# TorchAudio 2.11 (↔ PyTorch 2.11) for NVIDIA DRIVE Thor (SM110) — ARMv9 — CUDA 13.1 (driver 590+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.11"; pythonVersion = "313"; backend = "cuda"; sm = "110"; isa = "armv9"; cudaVersion = "13_1"; }
