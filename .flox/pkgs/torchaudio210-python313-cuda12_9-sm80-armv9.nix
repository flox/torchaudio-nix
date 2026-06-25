# TorchAudio 2.10 (↔ PyTorch 2.10) for NVIDIA A100 (ARM) (SM80) — ARMv9 — CUDA 12.9 (driver 560+)
{ pkgs ? import <nixpkgs> {} }:
import ./lib/mkTorchAudio.nix { taVersion = "2.10"; pythonVersion = "313"; backend = "cuda"; sm = "80"; isa = "armv9"; cudaVersion = "12_9"; }
