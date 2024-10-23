import torch
import torch
import torch.nn as nn
from torch.nn import functional as F
from dataclasses import dataclass


@dataclass
class ModelConfig:
    vocab_size: int
    n_embd: int
    n_head: int
    n_layer: int
    batch_size: int
    block_size: int
    learning_rate: float
    dropout: float = 0.2
    device: str = "cuda" if torch.cuda.is_available() else "cpu"

    @classmethod
    def get_config(cls, model_type: str):
        configs = {
            "shakespeare-200k": cls(
                vocab_size=65,
                batch_size=16,
                block_size=32,
                learning_rate=1e-3,
                n_embd=64,
                n_head=4,
                n_layer=4,
            ),
            "shakespeare-800k": cls(
                vocab_size=65,
                batch_size=32,
                block_size=64,
                learning_rate=6e-4,
                n_embd=128,
                n_head=4,
                n_layer=4,
            ),
            "shakespeare-10M": cls(
                vocab_size=65,
                batch_size=64,
                block_size=256,
                learning_rate=3e-4,
                n_embd=384,
                n_head=6,
                n_layer=6,
            ),
        }
        return configs.get(model_type)


class Head(nn.Module):
    """single head of self-attention"""

    def __init__(self, config, head_size):
        super().__init__()
        self.config = config
        self.key = nn.Linear(config.n_embd, head_size, bias=False)
        self.query = nn.Linear(config.n_embd, head_size, bias=False)
        self.value = nn.Linear(config.n_embd, head_size, bias=False)
        self.register_buffer(
            "tril", torch.tril(torch.ones(config.block_size, config.block_size))
        )

        self.dropout = nn.Dropout(config.dropout)

    def forward(self, x):
        B, T, C = x.shape
        k = self.key(x)  # (B,T,C)
        q = self.query(x)  # (B,T,C)
        # compute attention scores ("affinities")
        wei = q @ k.transpose(-2, -1) * C**-0.5  # (B, T, C) @ (B, C, T) -> (B, T, T)
        wei = wei.masked_fill(self.tril[:T, :T] == 0, float("-inf"))  # (B, T, T)
        wei = F.softmax(wei, dim=-1)  # (B, T, T)
        wei = self.dropout(wei)
        # perform the weighted aggregation of the values
        v = self.value(x)  # (B,T,C)
        out = wei @ v  # (B, T, T) @ (B, T, C) -> (B, T, C)
        return out


class MultiHeadAttention(nn.Module):
    """multiple heads of self-attention in parallel"""

    def __init__(self, config, num_heads, head_size):
        super().__init__()
        self.config = config
        self.heads = nn.ModuleList([Head(config, head_size) for _ in range(num_heads)])
        self.proj = nn.Linear(config.n_embd, config.n_embd)
        self.dropout = nn.Dropout(config.dropout)

    def forward(self, x):
        out = torch.cat([h(x) for h in self.heads], dim=-1)
        out = self.dropout(self.proj(out))
        return out


class FeedFoward(nn.Module):
    """a simple linear layer followed by a non-linearity"""

    def __init__(self, config):
        super().__init__()
        self.config = config
        self.net = nn.Sequential(
            nn.Linear(config.n_embd, 4 * config.n_embd),
            nn.ReLU(),
            nn.Linear(4 * config.n_embd, config.n_embd),
            nn.Dropout(config.dropout),
        )

    def forward(self, x):
        return self.net(x)


class Block(nn.Module):
    """Transformer block: communication followed by computation"""

    def __init__(self, config):
        super().__init__()
        self.config = config
        head_size = config.n_embd // config.n_head
        self.sa = MultiHeadAttention(config, config.n_head, head_size)
        self.ffwd = FeedFoward(config)
        self.ln1 = nn.LayerNorm(config.n_embd)
        self.ln2 = nn.LayerNorm(config.n_embd)

    def forward(self, x):
        x = x + self.sa(self.ln1(x))
        x = x + self.ffwd(self.ln2(x))
        return x


class LanguageModel(nn.Module):

    def __init__(self, config):
        super().__init__()
        self.config = config

        required_attrs = [
            "vocab_size",
            "n_embd",
            "n_head",
            "n_layer",
            "batch_size",
            "block_size",
            "learning_rate",
            "dropout",
            "device",
        ]

        for attr in required_attrs:
            assert hasattr(
                self.config, attr
            ), f"Config is missing required attribute: {attr}"

        self.token_embedding_table = nn.Embedding(
            self.config.vocab_size, self.config.n_embd
        )
        self.position_embedding_table = nn.Embedding(
            self.config.block_size, self.config.n_embd
        )
        self.blocks = nn.Sequential(
            *[Block(self.config) for _ in range(self.config.n_layer)]
        )
        self.ln_f = nn.LayerNorm(self.config.n_embd)
        self.lm_head = nn.Linear(self.config.n_embd, self.config.vocab_size)

    @classmethod
    def from_pretrained(cls, config, filePath):
        """Load a pretrained model from a saved state dict."""
        # Assert that all required config values are present
        required_attrs = [
            "vocab_size",
            "n_embd",
            "n_head",
            "n_layer",
            "batch_size",
            "block_size",
            "learning_rate",
            "dropout",
            "device",
        ]
        for attr in required_attrs:
            assert hasattr(
                config, attr
            ), f"Config is missing required attribute: {attr}"

        model = cls(config)
        model.load_state_dict(torch.load(filePath, weights_only=True))
        return model

    def num_parameters(self):
        return sum(p.numel() for p in self.parameters())

    def forward(self, idx, targets=None):
        B, T = idx.shape

        # idx and targets are both (B,T) tensor of integers
        tok_emb = self.token_embedding_table(idx)  # (B,T,C)
        pos_emb = self.position_embedding_table(
            torch.arange(T, device=self.config.device)
        )  # (T,C)
        x = tok_emb + pos_emb  # (B,T,C)
        x = self.blocks(x)  # (B,T,C)
        x = self.ln_f(x)  # (B,T,C)
        logits = self.lm_head(x)  # (B,T,vocab_size)

        if targets is None:
            loss = None
        else:
            B, T, C = logits.shape
            logits = logits.view(B * T, C)
            targets = targets.view(B * T)
            loss = F.cross_entropy(logits, targets)

        return logits, loss

    def generate(self, idx, max_new_tokens):
        # idx is (B, T) array of indices in the current context
        for _ in range(max_new_tokens):
            # crop idx to the last block_size tokens
            idx_cond = idx[:, -self.config.block_size :]
            # get the predictions
            logits, loss = self(idx_cond)
            # focus only on the last time step
            logits = logits[:, -1, :]  # becomes (B, C)
            # apply softmax to get probabilities
            probs = F.softmax(logits, dim=-1)  # (B, C)
            # sample from the distribution
            idx_next = torch.multinomial(probs, num_samples=1)  # (B, 1)
            # append sampled index to the running sequence
            idx = torch.cat((idx, idx_next), dim=1)  # (B, T+1)
        return idx

    def generate_stream(
        self, idx, max_new_tokens, temperature=1.0, top_k=None, top_p=None
    ):
        for _ in range(max_new_tokens):
            idx_cond = idx[:, -self.config.block_size :]
            logits, _ = self(idx_cond)
            logits = logits[:, -1, :] / temperature

            if top_k is not None:
                v, _ = torch.topk(logits, min(top_k, logits.size(-1)))
                logits[logits < v[:, [-1]]] = float("-inf")

            if top_p is not None:
                sorted_logits, sorted_indices = torch.sort(logits, descending=True)
                cumulative_probs = torch.cumsum(
                    F.softmax(sorted_logits, dim=-1), dim=-1
                )
                sorted_indices_to_remove = cumulative_probs > top_p
                sorted_indices_to_remove[..., 1:] = sorted_indices_to_remove[
                    ..., :-1
                ].clone()
                sorted_indices_to_remove[..., 0] = 0
                indices_to_remove = sorted_indices[sorted_indices_to_remove]
                logits[:, indices_to_remove] = float("-inf")

            probs = F.softmax(logits, dim=-1)

            idx_next = torch.multinomial(probs, num_samples=1)

            tokens = idx_next.tolist()
            for token in tokens:
                yield token

            idx = torch.cat((idx, idx_next), dim=1)

    def configure_optimizer(self):
        return torch.optim.AdamW(self.parameters(), lr=self.config.learning_rate)  # type: ignore


from data.shakespeare.character import decode, get_batch, estimate_loss, encode


# Generate text
def generate(prompt):
    device = "cuda" if torch.cuda.is_available() else "cpu"

    model_size = "800k"
    model_epoch = "20000"

    # Load the model configuration
    config = ModelConfig.get_config(f"shakespeare-{model_size}")
    assert config

    # Load the pretrained model
    model_path = f"weights/shakespeare-gpt-{model_size}-{model_epoch}.pth"
    model = LanguageModel.from_pretrained(config, model_path)
    model.to(device)

    model.eval()
    context = encode(prompt)
    generated_text = model.generate(context, max_new_tokens=500)
    return decode(generated_text[0].tolist())
