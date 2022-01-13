abstract class BaseError {
  abstract name: string;

  stack: string | undefined;

  constructor(public message: string) {
    this.stack = new Error().stack;
  }
}

export default class HttpError extends BaseError {
  name: string;

  constructor(response: Response, body: any) {
    const message = body?.message || `Received status code ${response.status}`;

    super(message);
    this.name = body?.error.name || 'HttpError';
  }
}
