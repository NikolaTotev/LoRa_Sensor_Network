import env from "react-dotenv";
import HttpError from "../errors/HttpError";

class HttpService {
  private baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  get<T>(path: string) {
    return this.request<T>(path, {
      method: 'GET'
    });
  }

  post<T>(path: string, body: {[key: string]: any}) {
    return this.request<T>(path, {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
      },
      body: JSON.stringify(body)
    });
  }

  private async request<T>(path: string, options: RequestInit): Promise<T> {
    const response = await fetch(`${this.baseUrl}/${path}`, options);

    if (!response.ok) {
      throw new HttpError(response, await response.json());
    }

    const responseBody = response.json();

    return responseBody
  }
}

const httpService = new HttpService(env.API_URL);
export default httpService;