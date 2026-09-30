# Ecosystem Indicator Workflows Development Plan
 
## Overview
 
This repository contains the **Ecosystem Indicator Workflows (EIW) Development Plan**, developed as part of the Ecosystem Indicator Workflows project.
 
The purpose of the Development Plan is to document stakeholder requirements and define a roadmap for the development of ecosystem indicator workflows over a two-year period. The plan is informed by requirements gathering activities including workshops, stakeholder interviews, community consultations, and project planning activities.
 
The document establishes:
 
- User groups and stakeholder communities.
- User requirements for ecosystem indicator workflows.
- High-level workflow requirements and constraints.
- Priority use cases.
- Development priorities for the first and second workflow delivery tranches.
- Review mechanisms for ongoing prioritisation.
- A framework for community engagement and future workflow investment.
 
The plan supports the delivery of a modular, reusable, and reproducible ecosystem indicator workflow ecosystem aligned with FAIR principles and recognised ecosystem assessment standards.
 
---
 
## What are Ecosystem Indicator Workflows?
 
Ecosystem Indicator Workflows (EIWs) are documented and reproducible computational workflows designed to support the development of ecosystem-specific and fit-for-purpose indicators.
 
Each workflow:
 
- Defines a target ecosystem.
- Identifies an intended assessment or reporting purpose.
- Documents the diagnostic mechanism linking indicators to ecosystem characteristics.
- Identifies appropriate indicator variables.
 
Workflows follow a common structure comprising:
 
1. Ecosystem data preparation
2. Indicator data preparation
3. Indicator calculation
4. Validation and uncertainty assessment
 
The workflow framework is designed to support transparency, reproducibility, interoperability, and long-term reuse.
 
---
 
## Project Objectives
 
The Development Plan addresses the following objectives:
 
1. Identify workflow functionality required by key user groups.
2. Document high-level workflow requirements and constraints.
3. Define use cases describing who uses workflows, how they use them, and the impacts generated.
4. Prioritise functionality for delivery during the first 12 months of the project.
5. Prioritise functionality for delivery during the second 12 months of the project.
6. Establish a review process to refine Year 2 priorities based on user feedback and project experience.
 
---
 
## Document Structure
 
The Development Plan is organised into the following sections:
 
### Part I – Context
 
- Executive Summary
- Introduction
- Requirements Gathering Activities
 
### Part II – User Needs
 
- User Groups
- User Requirements
- High-Level Workflow Requirements and Constraints
 
### Part III – Use Cases
 
- Detailed Use Cases
- Prioritisation Methodology
 
### Part IV – Development Roadmap
 
- Roadmap Overview
- First Tranche Priorities
- Second Tranche Priorities
- Tranche Review Process
 
### Part V – Monitoring and Evaluation
 
- Success Measures
 
### Appendices
 
- Workshop Summaries
- User Stories and use cases
- Requirements and use cases
 
---
 
## Building the Document
 
This project uses [Quarto](https://quarto.org/) to generate the final report.
 
### Prerequisites
 
Install:
 
- Quarto
 
Verify your installation:
 
```bash
quarto check
```
 
### Preview the document
 
```bash
quarto preview
```
 
### Render the document
 
Render all outputs:
 
```bash
quarto render
```
 
Render a specific format:
 
```bash
quarto render --to pdf
```