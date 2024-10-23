import os
import torch
import torch.distributed.rpc as rpc

from rpc.generate import generate


def run_worker():
    os.environ["MASTER_ADDR"] = "192.168.1.104"
    os.environ["MASTER_PORT"] = "29500"

    rpc.init_rpc("worker", rank=1, world_size=2)
    print("Worker initialized")
    # Waiting for requests
    rpc.shutdown()


if __name__ == "__main__":
    run_worker()
