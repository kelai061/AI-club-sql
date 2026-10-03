---
id: runoob-agent-python-rag
title: Python 实战 RAG 知识检索构建
type: share
author: 菜鸟教程
source: https://www.runoob.com/ai-agent/python-rag.html
category: 03-核心机制与记忆
created: '2026-10-03'
tags:
- AI-Agent
- 智能体
- 核心机制与记忆
- 'Python 实战 '
summary: Python 实现 RAG 与知识检索 本章节介绍检索增强生成（RetrievalAugmented Generation，RAG）技术。 RAG
  是构建知识密集型 Agent 的核心技术之一。 通过将向量检索与语言生成模型结合，RAG 让...
published: true
---

# Python 实战 RAG 知识检索构建

> **出处**：[https://www.runoob.com/ai-agent/python-rag.html](https://www.runoob.com/ai-agent/python-rag.html) ｜ **整理归档**：可莱 QQ-SQL 知识库 ｜ **分类**：`03-核心机制与记忆`

---

# Python 实现 RAG 与知识检索

本章节介绍检索增强生成（Retrieval-Augmented Generation，RAG）技术。

RAG 是构建知识密集型 Agent 的核心技术之一。

通过将向量检索与语言生成模型结合，RAG 让 Agent 具备了访问和利用外部知识的能力，而不再只能依赖模型参数中"记住"的内容。

## RAG 基础原理

RAG 的核心思想是把"信息检索"和"语言生成"两个环节结合起来，形成一条完整的问答链路。

当用户提出问题时，系统首先从知识库中检索出与问题相关的内容。

然后，系统把检索到的内容作为上下文提供给生成模型，辅助其产生更准确、更有依据的回答。

### 为什么需要 RAG

语言模型存在知识截止日期，无法感知训练完成之后发生的事情。

模型参数是有限的，不可能把世界上所有知识都记忆在参数里。

如果完全依赖模型从参数中"回忆"知识，遇到记不准或压根没学过的内容时，模型往往会一本正经地编造答案，这就是常说的"幻觉"（hallucination）。

RAG 的做法是让模型在回答前先去查真实资料，把"凭记忆答题"变成"开卷答题"，知识来源也可以随时更新，不必重新训练模型。

### 核心架构

一套完整的 RAG 系统通常包含三个核心组件：

检索器（Retriever）：负责从知识库中找出与问题最相关的信息片段。

向量数据库（Vector Store）：存储文档内容对应的向量表示，支持大规模、低延迟的相似度检索。

生成器（Generator）：基于检索到的内容和用户原始问题，生成最终的自然语言回答。

三者的关系可以理解为：检索器负责"找资料"，向量数据库负责"存资料、能快速找到相似的资料"，生成器负责"看着资料把答案组织出来"。

### 工作流程

第一步，**索引阶段**。将原始文档切分成若干文本块（chunks），逐一向量化后存入向量数据库，这一步通常是离线、提前完成的。

第二步，**检索阶段**。用户提出查询时，将查询同样向量化，在向量数据库中做相似度搜索，找出最相关的若干文本块。

第三步，**增强阶段**。把检索到的相关文本块与用户的原始问题拼接组合，构造成一份更完整的提示词（Prompt）。

第四步，**生成阶段**。生成模型基于这份增强后的上下文，产出最终回答。

这四步只有第一步是离线预处理，后三步都是用户提问时实时发生的，因此检索速度和检索质量直接决定了整个系统的响应速度和回答质量。

### 代码实现

## 基础 RAG 实现

class SimpleRAG:
    """
    简化版 RAG 系统实现
    包含三个核心组件：嵌入器、向量存储、生成器
    """

    def __init__(self, embedder, vector_store, generator):
        # 嵌入器：负责把文本转换为向量
        self.embedder = embedder
        # 向量数据库：负责存储向量并支持相似度检索
        self.vector_store = vector_store
        # 生成器：基于上下文生成回答
        self.generator = generator

    def add_documents(self, documents):
        """
        将文档添加到知识库
        :param documents: 原始文档列表（每个元素是一段完整文本）
        """
        # 第一步：把长文档切分为较小的文本块，便于精确检索
        chunks = self.chunk_documents(documents)

        # 第二步：将所有文本块转换为向量
        embeddings = self.embedder.embed(chunks)

        # 第三步：把向量与对应的原文一起存入向量数据库
        self.vector_store.add(embeddings, chunks)

    def chunk_documents(self, documents, chunk_size=500, overlap=50):
        """
        文档切分：把长文档拆成固定长度、有一定重叠的文本块

        :param documents: 原始文档列表
        :param chunk_size: 每个文本块的字符数
        :param overlap: 相邻文本块之间的重叠字符数（避免语义在切分处被截断）
        :return: 切分后的文本块列表
        """
        chunks = []
        for doc in documents:
            # 按 (chunk_size - overlap) 的步长滑动切分，保留一定重叠区域
            for i in range(0, len(doc), chunk_size - overlap):
                chunk = doc[i:i + chunk_size]
                chunks.append(chunk)
        return chunks

    def query(self, question, top_k=5):
        """
        处理用户查询，返回生成的回答

        :param question: 用户提出的问题
        :param top_k: 检索时返回的相关文本块数量
        :return: 生成模型给出的最终回答
        """
        # 1. 把问题转换为向量，才能与知识库中的向量做比较
        question_embedding = self.embedder.embed([question])[0]

        # 2. 在向量数据库中检索最相似的 top_k 个文本块
        results = self.vector_store.search(question_embedding, top_k)

        # 3. 把检索到的文本块拼接成上下文
        context = "\n".join([doc for doc, _ in results])

        # 4. 把上下文和原始问题一起组织成提示词
        prompt = f"基于以下内容回答问题：\n{context}\n\n问题：{question}"

        # 5. 交给生成模型产出最终回答
        return self.generator.generate(prompt)

这套基础实现已经能跑通完整的 RAG 流程，但在实际项目中往往还不够用：切分方式过于简单粗暴，检索排序也只依赖一次向量相似度计算，精度有限。下面介绍几种常见的优化思路。

## Advanced RAG

基础 RAG 常见的问题包括：检索到的内容质量不高、排序不够精确、上下文里混入不相关信息等。

Advanced RAG 通过引入重排序、混合检索等技术手段，在基础流程之上做进一步优化，从而提升最终回答的准确性。

### 重排序（Reranking）

基础 RAG 的向量检索速度快，但排序精度有限，容易把语义上不够贴切的内容排到前面。

重排序的做法是：先用向量检索快速筛出一批候选文本（比如 top-20），再用计算量更大但更精确的交叉编码器（Cross-Encoder）对这些候选逐一打分，重新排序后取出真正最相关的少数几条（比如 top-5）。

这种"先粗筛、再精排"的两阶段思路，兼顾了检索速度和检索精度。

## 带重排序的 RAG

class AdvancedRAG:
    """
    高级 RAG 系统
    在基础流程之上增加重排序环节
    """

    def __init__(self, embedder, vector_store, reranker, generator):
        # 嵌入器
        self.embedder = embedder
        # 向量数据库
        self.vector_store = vector_store
        # 重排序模型（交叉编码器），用于精细化排序
        self.reranker = reranker
        # 生成器
        self.generator = generator

    def query(self, question, initial_k=20, final_k=5):
        """
        处理查询，包含"粗筛 + 精排"两阶段检索

        :param question: 用户问题
        :param initial_k: 第一阶段向量检索返回的候选数量
        :param final_k: 重排序后最终保留的数量
        """
        # ==================== 阶段1：初步检索（粗筛） ====================
        # 把问题转换为向量
        question_embedding = self.embedder.embed([question])[0]

        # 用向量相似度快速召回一批候选文本（速度快，精度一般）
        initial_results = self.vector_store.search(
            question_embedding,
            initial_k
        )

        # ==================== 阶段2：重排序（精排） ====================
        # 构造 (问题, 候选文档) 配对，交给交叉编码器逐一打分
        doc_pairs = [(question, doc) for doc, _ in initial_results]

        # 交叉编码器会同时编码问题和文档，能更精确地判断两者的相关性
        reranked = self.reranker.rerank(doc_pairs)

        # 取重排序后真正最相关的 final_k 条
        final_context = "\n".join([doc for doc, _ in reranked[:final_k]])

        # ==================== 阶段3：生成 ====================
        prompt = f"上下文：{final_context}\n\n问题：{question}"
        return self.generator.generate(prompt)

### 混合检索

混合检索（Hybrid Retrieval）结合了稠密检索与稀疏检索各自的优势。

稠密检索（Dense Retrieval）基于向量相似度，擅长捕捉语义层面的相关性，即使用户提问和文档没有用完全相同的词，也能匹配上。

稀疏检索（如 BM25）基于关键词的词频统计，擅长精确的字面匹配，对专有名词、编号、代码片段等场景往往比向量检索更可靠。

两者各有盲区：向量检索可能"理解了意思但找不到确切的关键词"，关键词检索则可能"匹配了词但理解不了语义"。混合检索把两条检索路径的结果融合起来，取长补短。

## 混合检索 RAG

class HybridRAG:
    """
    混合检索 RAG
    结合稠密检索（向量）和稀疏检索（关键词）
    """

    def __init__(self, dense_retriever, sparse_retriever, fusion_fn):
        # 稠密检索器：基于向量相似度，擅长语义匹配
        self.dense_retriever = dense_retriever
        # 稀疏检索器：基于关键词统计（如 BM25），擅长精确匹配
        self.sparse_retriever = sparse_retriever
        # 融合函数：用于合并两路检索结果，例如 RRF（见下方实现）
        self.fusion_fn = fusion_fn

    def query(self, question, top_k):
        """
        执行混合检索，返回融合排序后的结果

        :param question: 用户问题
        :param top_k: 最终返回的结果数量
        """
        # ==================== 稠密检索 ====================
        # 多召回一些候选（top_k * 2），留出融合时筛选的空间
        dense_results = self.dense_retriever.search(question, top_k * 2)

        # ==================== 稀疏检索 ====================
        # 基于关键词的检索，同样多召回一些候选
        sparse_results = self.sparse_retriever.search(question, top_k * 2)

        # ==================== 结果融合 ====================
        # 使用 Reciprocal Rank Fusion（RRF）等策略融合两路排序结果
        fused = self.fusion_fn(dense_results, sparse_results)

        # 取融合后排名最高的 top_k 条
        return fused[:top_k]

def reciprocal_rank_fusion(results_a, results_b, k=60):
    """
    Reciprocal Rank Fusion（RRF）算法
    用于把两路（或多路）检索的排序结果融合成一个统一排序

    核心思路：只看每个文档在各路结果里的"排名"，而不是具体分数，
    避免了向量相似度分数和 BM25 分数量纲不同、无法直接比较的问题。

    :param results_a: 检索结果 A，格式为 [(doc, score), ...]
    :param results_b: 检索结果 B，格式为 [(doc, score), ...]
    :param k: 平滑常数，用于降低排名靠后的文档的权重差异，通常取 60
    :return: 按融合分数从高到低排序的 [(doc, score), ...] 列表
    """
    scores = {}

    # 处理结果 A：排名越靠前，贡献的分数越高
    for rank, (doc, _) in enumerate(results_a):
        scores[doc] = scores.get(doc, 0) + 1 / (k + rank + 1)

    # 处理结果 B，同样按排名累加分数
    for rank, (doc, _) in enumerate(results_b):
        scores[doc] = scores.get(doc, 0) + 1 / (k + rank + 1)

    # 按累加后的融合分数从高到低排序
    sorted_docs = sorted(scores.items(), key=lambda x: -x[1])

    return sorted_docs

### 其他优化策略

**查询扩展**：通过补充同义词或相关词来扩展原始查询，扩大召回范围，提升召回率。

**查询改写**：借助模型理解用户的真实意图，把口语化、模糊的问题改写成更适合检索的表述。

**上下文压缩**：在把检索结果交给生成模型之前，先去除冗余、不相关的部分，只保留关键信息，既能降低成本，也能减少生成模型被无关内容干扰的风险。

## 向量数据库

向量数据库是 RAG 系统的基础设施，负责存储海量的高维向量，并支持大规模、低延迟的相似度检索。

### 核心概念

**嵌入（Embedding）**：把文本（或图像、音频等）转换为一组稠密数值向量的过程，语义相近的内容在向量空间中的距离也会更近。

**向量维度**：嵌入向量的长度。维度越高，理论上能表达的语义信息越丰富，但存储和计算开销也会随之增加。

**相似度度量**：用来衡量两个向量之间"相似程度"或"距离"的具体计算方法，不同度量方式适合不同场景。

### 常用相似度度量

| 度量方法 | 公式 | 特点 | 适用场景 |
| --- | --- | --- | --- |
| 余弦相似度 | cos(A,B) = A·B/(|A||B|) | 只衡量方向上的相似性，与向量长度无关，取值范围 [-1,1] | 文档/文本相似度 |
| 欧氏距离 | d(A,B) = sqrt(sum((Ai-Bi)^2)) | 衡量向量间的绝对空间距离，取值范围 [0,+∞) | 图像特征匹配 |
| 点积 | A·B = sum(Ai*Bi) | 同时受方向和长度影响，计算效率高 | 推荐系统 |

### 主流向量数据库对比

| 数据库 | 类型 | 特点 | 适用场景 |
| --- | --- | --- | --- |
| Pinecone | 云服务 | 全托管服务，上手简单，自动扩容，无需自行运维 | 希望快速上线的生产环境 |
| Weaviate | 开源 | 原生支持混合检索（向量 + 关键词），模块化程度高 | 需要灵活定制检索逻辑的场景 |
| Milvus | 开源 | 高可用、易水平扩展，可支撑十亿级以上向量规模 | 超大规模向量检索 |
| Chroma | 开源 | 轻量级、API 简洁，几行代码即可跑起来 | 原型开发、教学与本地测试 |
| Qdrant | 开源 | 基于 Rust 实现，性能优秀，支持丰富的过滤条件 | 需要高吞吐、复杂过滤的场景 |

### 代码示例

## 使用 Chroma 向量数据库

import chroma_client
from chroma_client import ChromaClient

# 创建客户端（可连接本地实例，也可连接远程服务）
client = ChromaClient()

# 创建或获取一个集合（Collection），相当于关系型数据库里的"表"
collection = client.get_or_create_collection("knowledge_base")

# 添加文档：ID、向量、原文、元数据需要一一对应
collection.add(
    ids=["doc1", "doc2", "doc3"],  # 每条文档的唯一标识
    embeddings=[
        [0.1, 0.2, 0.3],  # 文档1对应的向量（实际维度通常远高于3维）
        [0.4, 0.5, 0.6],  # 文档2对应的向量
        [0.7, 0.8, 0.9],  # 文档3对应的向量
    ],
    documents=[
        "人工智能是计算机科学的一个分支",
        "机器学习是人工智能的子领域",
        "深度学习是机器学习的子领域"
    ],
    metadatas=[
        {"source": "教科书"},  # 文档1的来源信息，可用于后续过滤
        {"source": "论文"},
        {"source": "论文"}
    ]
)

# 检索：传入查询向量，返回最相似的 n_results 条结果
results = collection.query(
    query_embeddings=[[0.15, 0.25, 0.35]],  # 查询对应的向量
    n_results=2  # 返回 top-2 最相似的结果
)

# 输出检索结果
print(results["documents"])   # 命中的原文内容
print(results["distances"])   # 对应的距离/相似度分数，数值越小通常表示越相似

> 选择向量数据库时，需要综合考虑数据规模、查询延迟要求、部署方式（云托管 or 自建）以及团队的运维能力。小规模原型开发优先选 Chroma，追求开箱即用的生产环境可以选 Pinecone，超大规模、需要自主可控的场景更适合 Milvus 或 Qdrant。

## GraphRAG

GraphRAG 是将知识图谱（Knowledge Graph）与 RAG 结合的一种进阶方案。

它通过构建实体与关系组成的图结构，来增强系统的检索和推理能力。

### 为什么需要 GraphRAG

传统 RAG 基于文本块的相似度检索，难以处理需要"多跳推理"的问题（即答案需要串联多条信息才能得出）。

传统 RAG 也不容易显式地捕获实体之间的语义关系，例如"谁是谁的上级""哪家公司收购了哪家公司"这类结构化信息。

GraphRAG 把这些实体和关系显式地组织成图结构，让系统能够沿着关系路径进行推理，而不只是"找相似文本"。

### 核心优势

能够捕获实体之间的语义关系，形成结构化的知识网络，而不只是零散的文本片段。

支持基于路径的推理，可以更好地回答关系型问题。

能够处理需要多跳（multi-hop）推理的复杂问题，例如"某人的导师的导师是谁"这类需要连续跨越多个关系节点才能得出答案的问题。

### 代码实现

## GraphRAG 实现

class GraphRAG:
    """
    GraphRAG 系统
    结合知识图谱检索与向量检索，兼顾关系推理与语义相似度
    """

    def __init__(self, kg_builder, embedder, vector_store, generator):
        # 知识图谱构建器：负责实体/关系抽取与图谱查询
        self.kg_builder = kg_builder
        # 嵌入器：用于将文档和问题转换为向量
        self.embedder = embedder
        # 向量数据库：作为知识图谱检索的补充通道
        self.vector_store = vector_store
        # 生成器：基于融合后的上下文生成最终回答
        self.generator = generator

    def index_documents(self, documents):
        """
        将文档同时索引到知识图谱和向量数据库
        :param documents: 文档列表
        """
        for doc in documents:
            # 从文档中提取实体
            # 例如从"OpenAI 成立于 2015 年"中提取出
            # 实体：OpenAI（组织）、2015年（时间）
            entities = self.kg_builder.extract_entities(doc)

            # 从文档中提取实体间的关系
            # 例如提取出关系三元组：(OpenAI, 成立于, 2015年)
            relations = self.kg_builder.extract_relations(doc)

            # 把实体和关系写入知识图谱
            self.kg_builder.add_entities(entities)
            self.kg_builder.add_relations(relations)

            # 同时把原文向量化后存入向量数据库，用于补充语义检索
            embedding = self.embedder.embed([doc])
            self.vector_store.add(embedding, [doc])

    def query(self, question):
        """
        处理查询：结合知识图谱推理和向量检索
        """
        # ==================== 知识图谱检索 ====================
        # 先找出问题中涉及的相关实体
        # 例如"谁创立了 OpenAI？" -> 识别出实体 "OpenAI"
        relevant_entities = self.kg_builder.query_entities(question)

        # 基于这些实体，取出图谱中与之直接相关的子图
        # 子图包含相关实体及其邻接节点、连接边
        subgraph = self.kg_builder.get_subgraph(relevant_entities)

        # ==================== 向量检索 ====================
        # 作为补充通道，检索语义相似的文本内容
        vector_results = self.vector_store.search(question, top_k=5)

        # ==================== 结果融合 ====================
        # 把图谱推理结果与向量检索结果融合为统一上下文
        combined_context = self.fuse_results(subgraph, vector_results)

        # ==================== 生成 ====================
        return self.generator.generate(combined_context, question)

    def fuse_results(self, subgraph, vector_results):
        """
        融合知识图谱子图与向量检索结果，组织成生成模型可读的上下文文本
        """
        # 把子图转换为自然语言描述（如"OpenAI -成立于-> 2015年"）
        kg_text = subgraph.to_text()

        # 拼接向量检索到的原文片段
        vector_text = "\n".join([doc for doc, _ in vector_results])

        return f"{kg_text}\n{vector_text}"

class KnowledgeGraphBuilder:
    """知识图谱构建器（示意实现，实际项目中通常调用专门的 NER/关系抽取模型）"""

    def extract_entities(self, text):
        """
        从文本中提取命名实体，通常借助 NER（命名实体识别）模型完成
        实体类型常见的有 PERSON（人物）、ORG（组织）、TIME（时间）等
        """
        entities = []
        return entities

    def extract_relations(self, text):
        """
        从文本中提取实体间的关系，通常借助关系抽取（Relation Extraction）模型完成
        关系一般表示为三元组：(头实体, 关系类型, 尾实体)
        """
        relations = []
        return relations

    def query_entities(self, question):
        """根据用户问题，识别出问题中涉及的实体，用于后续的子图检索"""
        return []

### 应用场景

GraphRAG 尤其适合以下场景：

需要理解实体关系的问答，例如"这家公司的 CEO 是谁"。

需要多跳推理才能得出答案的问题，例如"张三的导师的导师是谁"。

需要挖掘知识库中隐含、未被显式写出的关系的场景。

需要注意的是，构建和维护知识图谱本身有一定的工程成本（实体/关系抽取的准确率、图谱更新维护等），因此更适合对关系推理有明确需求的场景，而不建议作为所有 RAG 项目的默认起点。

## 方案对比与选择建议

| 方案 | 核心思路 | 优势 | 局限 | 适用场景 |
| --- | --- | --- | --- | --- |
| 基础 RAG | 向量检索 + 直接生成 | 实现简单，成本低，上手快 | 检索精度有限，容易召回不够相关的内容 | 简单问答、快速原型验证 |
| Advanced RAG（重排序） | 向量粗筛 + 交叉编码器精排 | 显著提升检索排序的精确度 | 多了一次模型推理，延迟和成本增加 | 对回答准确性要求较高的场景 |
| 混合检索 | 向量检索 + 关键词检索融合 | 兼顾语义匹配与精确关键词匹配 | 需要同时维护两套检索索引 | 专有名词、代码、编号较多的知识库 |
| GraphRAG | 知识图谱 + 向量检索融合 | 支持关系推理和多跳问答 | 图谱构建与维护成本较高 | 关系型、多跳推理需求明确的场景 |

## 章节小结

本章节介绍了 RAG 与知识检索的核心技术。

RAG 基础原理：通过将检索与生成结合，让 Agent 能够利用外部知识回答问题，而不是完全依赖模型参数中的记忆。

Advanced RAG：通过重排序、混合检索等技术，在基础流程之上进一步提升检索质量和回答准确性。

向量数据库：是 RAG 系统的基础设施，负责高效存储和检索文档的向量表示，选型需结合数据规模与部署方式综合判断。

GraphRAG：结合知识图谱，增强了关系推理和多跳问答能力，但也带来了额外的构建与维护成本。

选择合适的 RAG 方案，核心是先看清业务场景的真实需求：简单问答场景，基础 RAG 往往已经足够；对检索精度有较高要求，可以引入重排序；知识库中专有名词/关键词较多，适合加入混合检索；涉及大量关系推理和多跳问答，再考虑引入 GraphRAG。技术越复杂，工程和维护成本也越高，按需选择比一味追求"更高级的方案"更重要。

  其他扩展
