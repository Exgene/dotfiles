import os
import torch
import torch.distributed.rpc as rpc
from concurrent.futures import as_completed

# from shared_functions import process_tensor
from rpc.generate import generate


def run_master():
    os.environ["MASTER_ADDR"] = "192.168.1.104"
    os.environ["MASTER_PORT"] = "29500"

    rpc.init_rpc("master", rank=0, world_size=2)
    print("Master initialized")

    # Create a tensor
    tensor = torch.tensor([1, 2, 3])
    print("Sending tensor to worker:", tensor)

    # Send the tensor to the worker and get the result
    # result = rpc.rpc_sync(
    #     "worker", generate, args=("Though this be madness, yet there is method in't",)
    # )

    futures = []

    # Send tasks to worker1 and worker2
    futures.append(
        rpc.rpc_async(
            "worker1",
            generate,
            args=("Though this be madness, yet there is method in't",),
        )
    )
    futures.append(
        rpc.rpc_async(
            "worker2",
            generate,
            args=("Though this be madness, yet there is method in't",),
        )
    )

    # Use as_completed to handle results as soon as they complete
    for future in as_completed(futures):
        result = (
            future.result()
        )  # This will not block, as we get the result from already completed futures
        print("Received processed result:", result)

    print("Received processed tensor from worker1:", result1)
    print("Received processed tensor from worker2:", result2)
    # print("Received processed tensor from worker:", result)

    rpc.shutdown()


if __name__ == "__main__":
    run_master()
