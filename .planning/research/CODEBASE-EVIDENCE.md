# Codebase Evidence — Commit-Verified Accomplishments (Ashutosh Tiwari)

Mined 2026-08-21 from ~/code/ Adobe repos for milestone v1.0 (Staff MLE resume optimization).
Attribution verified by author email (`astiwari@adobe.com` / `findashutoshtiwari@gmail.com`).
**Excluded:** Ashutosh Sharma (`ashutosh@adobe.com`, colligo Text2Design workstream) and Ashutosh Sanan (`asanan@adobe.com`, Gabby video endpoint) — different people.

## Honest-framing rules (binding for all resume work)

- **NO commit evidence** for: TensorRT/TRT-LLM, CUDA graphs, speculative decoding, quantization, MoE / tensor / pipeline parallelism. Never claim as accomplishments.
- Closest defensible: `torch.compile(mode="max-autotune")` in production (his), ONNX Runtime CUDAExecutionProvider (his), FSDP/FSDP2 + DDP multi-node execution (framework he built modules for and ran), vLLM (operated/platform context).
- Styx OTel Rust instrumentation = branch-only prototype; merged observability credit = Grafana/Alloy/Loki/Tempo infra PRs (#692/#732/#779/#878).
- Content Gate (#1706/#1870) = training-data governance/lineage — strong for "fault-tolerant distributed systems in Rust", not inference optimization.
- asml DAG scaffold + ff-data-ingestion skeleton authored by teammates — his role there is hardening, reliability, ownership of specific jobs.

---

## orion — Adobe Firefly MLOps platform (Rust/axum "Styx" API, K8s GPU pipelines)

Platform: plugin-based Source → Transform → Sink pipelines, KEDA autoscaling on SQS depth, BuildKit→ECR builds, dataset/asset/lineage tracking.

**A. GPU batch-inference enrichment plugin (`styx_enrichment`)** — his largest inference contribution (#307, #357, #447 +5.9k lines; precursors #298/#301)
- Three production image models (AIDE GenAI-detector, HydraNet face, ResNet50 GenAI classifier) as SQS-fed batched GPU inference pipelines on K8s/Pluto, writing to Feature Registry.
- `producer_base.py` (333 ln): streaming SQS producer, bounded memory, SendMessageBatch chunking, partial-failure retry w/ exponential backoff + full jitter (5 attempts, 30s cap).
- `checkpoints.py` (445 ln): concurrency-safe S3 checkpoint cache on local SSD — file locking w/ stale-lock PID detection, ETag/size revalidation, fail-open to known-good cache.
- GPU inference offloaded to background thread (`asyncio.to_thread`) so async SQS/IO event loop never blocked by CUDA work (`1404e2c77`).
- Per-model slim Docker images (extras-driven `uv pip compile`), declarative per-model `batch.yaml`, 425-ln ARCHITECTURE.md + 364-ln runbook, integration test harness.
- GPU targets: default `p4de.24xlarge` (A100 80GB); supported `p5.48xlarge` (H100), g5/g6.

**B. Content Gate / L2 training-data monitoring (Rust)** — `531905c1f` #1706, **+27,135 lines solely his**
- fingerprint.rs (520), sample_index.rs (1,387), routers (validation.rs 3,025, types.rs 1,442, record.rs 749, …), 6 SQL migrations, frozen cross-runtime contract doc (422 ln): training-checkpoint lineage events, immutable S3 evidence layouts, canonical sample identity, token fingerprinting, claim/receipt idempotent registration, manifest-after-data publication. 9,722-ln integration test + 1,710-ln contract checker.
- #1870: self-service RS256 JWT research-token minting — k8s-Secret-mounted signing key, graceful 503 degradation, redacting Debug, compile-time no-token-leak probes.
- Supporting: Aurora Limitless index fix (#1823), IRSA read access (#1859), CloudFront WAF for L2 EMR NAT EIPs (#1868).

**C. 202.6M-row image dataset migration** (branch `ashutosh/image-dataset-migration`, 27 commits)
- Source: `s3://ff-metadata-delivery/qoi-delivery/...` ~202.6M rows (README:12). K8s Indexed Jobs.
- Reliability per-commit: fail-fast env contract; 14-check payload-contract registry; deterministic sharding by stable hash + resumable scan (re-runs converge); asymmetric retry + circuit breaker + full run report; post-send timeouts terminal (`unknown_timeout`, reconciled by next run's probe — never blind-resent); atomic report persistence (tmp+`os.replace`); capped ExpiredToken restarts; DuckDB streaming scan; typed-name prod confirmation gates (stg 250/shard; prod 200k/shard × 4 shards).

**D. Video clips migration — 24.8M clips** (#1139 merged, co-authored w/ J. Mracek)
- 618 parquet shards → Styx dataset via 16-pod K8s Indexed Job; per-rendition (256/512/1080/native) video-slice groups with time-range slices; storage-URI dedup.

**E. Observability (merged):** Loki TF (#692), alloy-gateway OTLP memory_limiter (#732), +2,048-ln telemetry-pipeline-health Grafana section + ServiceMonitors for Alloy/Loki-write/Tempo (#779), PromQL guard (#878). Branch-only OTel Rust instrumentation (~60 commits) = "prototyped/designed" only.

**F. K8s cluster-capacity API (#675):** GET cluster capacity + per-pod scheduling status in Rust API; surfaces FailedScheduling/Unschedulable events, batched event LIST, k3d-gated tests.

Platform context (others — "platform that…" framing only): vLLM plugins + OTS vLLM H100 throughput ladder (concurrency 8→128, 8,192-token), torch.compile cache-shard combining plugin, O(1B)-scale producer jobs.

---

## genie — Firefly training dataloader (image/audio/video) + Glimmer batch-inference framework

Glimmer: YAML-configured PyTorch-Lightning inference jobs (DDP/FSDP, multi-node) on Pluto/Run:ai, DuckDB-SQL-over-S3-parquet input, Feature-Registry writer.

**A. Production model onboarding onto Glimmer (4 models, merged main):**
- **Content-Type Classifier** (#1611, #1619): CLIP ViT-B/32 + head; **introduced `torch.compile(mode="max-autotune")` on encoder + classifier** (`glimmer/modules/dp/content_type_classifier/module.py:76-77`); ran prod job (11 daily feature-store partitions/run).
- **Vector-asset classifier** (#1727, +778 ln): custom dual-head ViT (reject head + 4-class icon/pattern/scene/subject), S3-versioned model loading, S3 utility layer, full tests.
- **CAI duplicate-detection embeddings** (#2035/#2037, +555 ln): **ONNX Runtime CUDAExecutionProvider** fingerprint embedding generator; dups indexing fixes.
- **AIDE GenAI-image detector** (#2060, +1,091 ln): full AIDE architecture as Glimmer module — 30 SRM high-pass filter banks, DCT patch decomposition w/ min/max frequency-grade selection, dual ResNet-50 branches, frozen OpenCLIP ConvNeXt-XXLarge (laion2B) branch, MLP fusion head; TF32 matmul; then throughput tuning (`350288acb`: batch 64→128, threads 2→4, removed 1M-row LIMIT for full-span run).
- His AIDE module benchmarked on the Ray Data engine (doc by Joel C.): 1×p4d.24xlarge (8×A100), 16 fractional-GPU actors (0.5 GPU each), 1,087,682 rows @ 109 rows/s steady — legit as "his module benchmarked on Ray engine".

**B. Operated Sep-2025 Firefly data-release enrichment fleet:**
- Updated configs for **9 production modules** (adobe+laion aesthetics, CTC, ConvNeXt+ResNet50 GenAI detection, HydraNet, language classifier, people detection, text presence) + multi-node launch templates.
- Launch records: `--num-nodes 3 --num-gpus 8 --accelerator-type NVIDIA_A100_40GB` per module = **24×A100-40GB per model job × 9 queues**.

**C. Genie dataloader core (merged):**
- Raw/native-image ingestion path (`get_image(raw_image=…)`) w/ vector-format (svg/eps/zip→png) handling, PIAT fallback, Skip semantics (#719/#725); NumPy resize stage (#738/#740).
- **Skip-rate guard hardening** (`22242ca0a`): data-corruption circuit breaker — SkipRateExceeded propagation in threadpool mode, lock-protected counters w/ lock-free fast path, concurrency regression tests.
- CI-runner fleet: preemptible allocation, fixed silently-skipped tarball checksum verification, per-pod work-dir isolation stopping cross-pod git-worktree corruption (#2876+).

**D. Training-data curation configs:** DuckDB SQL joins over disco-feature-store parquet joining dozens of curated signals; `clio4_genie_multi_700M.yaml` (700M-param model config), release configs.

---

## colligo — Adobe AI Platform monorepo (29 merged commits his, +4,754/−2,426)

**A. GPU batch-inference FCU pipelines (Aug–Oct 2024):**
- **Led "Simplica-free" architecture migration** of the data-platform inference path: `FeatureComputeUnit2ABC` w/ pluggable `pipeline_executor`, per-record vs per-batch inference toggle, GPU-vs-CPU pipeline routing; migrated Depth + LAION-aesthetics models (`88d227e5c9f`, `267c98db4f4`).
- GPU allocation/scheduling fixes on shared inference cluster (CoCa text embeddings, LLaVA-OCR, HED/Mask2Former scribble, language classifier).
- **Built FCU output data-validation framework** — `AssetValidationRunner` wired into ~20 model pipelines w/ per-pipeline threshold gating (`fdfc2b1b8d3`, `fd8becce47b`).

**B. disco-feature-store ingestion/backfill (2025):** sharded backfill path; blob-column lifecycle fixes (asyncio event-loop bug making blobs null under newer torch image); removed sensei-fs dependency from Pluto submission.

**C. Pluto dataset/enrichment control plane (Nov 2025–Feb 2026):**
- **Job-queue stats system (3 services + worker, +1,049 ln)**: monitor (Pluto entity search → Redis, 60s per-queue rate limit), worker (Glimmer DB stats, throughput calc), update service (batched entity updates: 50/batch, 3s flush) (`8ffbb83d810`).
- Decoupled hydration worker from ECS control-plane DB (query_id in message; −193 ln coupling) (`f85a7bff644`).
- Auto-start enrichment jobs on hydration completion + service-principal permission check (+751 ln incl. 440 tests) (`977fb35aeab`).
- Root-caused async SQLAlchemy `greenlet_spawn` failure (async PG URL w/ sync session); vault→k8s secrets migration.
- Fault-tolerance patterns in services he authored/refactored: Redis consumer groups, DLQ, delivery-count retry (cap 5), **lease/TTL heartbeat (30s TTL extended every 20s, 3600s cap)**, transient-vs-permanent error classification, ConsecutiveFailureTracker circuit breaker.
- Scale: Stock training-data catalog he maintained totals **~700M enriched assets** (largest dataset 206.8M; +35–38M images/month).

---

## asml-img-data-dags — Airflow enrichment pipeline (75/190 commits his, Jun 2026)

- **Root-caused 6-week silent outage** (package rot broke genie[glimmer] venv installs); fixed + added install/import smoke-test CI that would have caught it; SHA-pinned genie builds.
- **Fault tolerance on preemptible GPU fleets:** made Glimmer-queue drain the authoritative success signal (Pluto job state noisy under preemption); idempotent re-runs (`skip_existed=true`); stale-queue drop-before-create; window fallback to latest `_SUCCESS` day; `--preemptible --enable-autorecovery v2` backfills.
- Concurrency control: capped concurrent GPU modules at 6 via Airflow pool.
- Deployment tooling (100% his): one-command Airflow-node provisioning on Pluto (`launch_airflow_node.sh`, 31 commits), on-demand enrichment triggers, operational queue driver, Slack notification hardening, per-table FR version pinning, test/prod S3 env toggle.
- Scale: 8 feature modules × 8×H100-80GB nodes per job (**64 H100s across the parallel wave**; ARCHITECTURE.md documents 5-node = 40-H100/module option). Input = the FCU0 daily export **his own ff-data-ingestion job produces** (cross-repo ownership narrative).

---

## ff-data-ingestion — daily Stock ingestion (15 commits main)

- Owns evolution of **FCU0 export**: daily Spark job joining `image_metadata`+`qoi_metadata` **Iceberg** tables → Feature Registry parquet + DynamoDB pointer batch-upload; content-safety block-word filter.
- Spark reliability/perf: dynamic partition count (10–2,500 targeting 10–30k records/partition), worker reuse, `task.maxFailures=5`, Kryo; repartition+cache fixing skewed S3 writes; EXIF extraction at scale (exiftool tag pivoting).
- Authored 320-ln entitlements→FR sync Spark job as EMR step (160 executors × 3 cores).
- Prod ingestion runs on **40-node EMR daily**; 35–38M images/month flow through.

## ff-data-engineering — feature-registry library

- **STS assume-role storm fix** (`46665c4`, +457 ln): failed AssumeRole never populated session caches → thousands of STS calls/sec + throttling (trigger: 12h session duration rejected under role chaining). Fix: shared negative cache w/ 60s cooldown + exactly-one half-open retry (circuit-breaker semantics), duration env-tunable across all nine session/client getters; 8-thread thundering-herd collapse test.
- Branch (unmerged, "in progress" only): access-monitoring system (+29.5k ln): canonical sample keys, receipt-backed token evidence, lineage entity resolver w/ bounded graph traversal, 5 Spark steps, SAM stacks, EMR Serverless hardening.

## fetools — Rust/Axum + Vue console (17 commits, Aug 2026)

- Monitoring console over Orion: Rust status-preserving proxy (`send_any_status`), cursor-paginated report history, MSW + wiremock test layers.
- Security hardening: path-traversal-proof sample-key validation (rejected keys answer Orion's own 400 shape with zero upstream requests, proven by test), proxy response stamping disambiguating upstream 401 vs session expiry.
- Content-gate token minting end-to-end (15 commits, TDD): token-hygiene invariant mechanized in tests (minted token never logged/persisted), base64url JWT claim decoding, redaction from parse-failure logs.

---

## Cross-repo scale summary (all citations above)

- 202.6M-row image ingest (K8s Indexed Jobs, sharded, resumable)
- 24.8M video clips / 618 shards / 16-pod Indexed Job
- ~700M-asset enriched training catalog; +35–38M images/month
- 24×A100-40GB per model job × 9 queues (Sep release); 64 H100s parallel enrichment wave
- A100-80GB default / H100 supported GPU fleet for enrichment pipelines
- 40-node EMR daily ingestion; 160-executor Spark steps
- +27,135-line production Rust governance subsystem (9.7k-ln integration test)
- Platform context: O(1B)-scale producer jobs, H100 vLLM throughput ladders (others' work)
