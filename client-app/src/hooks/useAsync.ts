import { useEffect, useState } from "react";

interface AsyncState<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
}

export default function useAsync<T>(action: () => Promise<T>, depencies: any[]) {
  const [state, setState] = useState<AsyncState<T>>({
    data: null,
    loading: true,
    error: null
  });

  const reload = () => {
    let isCancelled = false;
    (async function () {
      try {
        setState({data: null, loading: true, error: null});
        const result = await action();

        if (!isCancelled) {
          setState({data: result, loading: false, error: null});
        }
      } catch (error: unknown) {
        if (error instanceof Error && !isCancelled) {
          setState({data: null, loading: false, error});
        }
      }
    })();

    return (() => {isCancelled = true;});
  };

  useEffect(reload, depencies);

  return {...state, reload};
}
