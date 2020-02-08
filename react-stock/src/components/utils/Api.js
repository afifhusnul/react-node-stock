import axios from "axios";

export default axios.create({
  baseURL: "http://192.168.43.133:3001/api/",
  responseType: "json"
});