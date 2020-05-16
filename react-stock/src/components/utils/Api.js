import axios from "axios";

export default axios.create({
  baseURL: "http://192.168.200.100:3001/api/",
  responseType: "json"
});
